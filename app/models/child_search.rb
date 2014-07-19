class ChildSearch
  def results
    search.execute.results
  end

  def paginated(page, per_page)
    search.build do
      paginate page: page, per_page: per_page
    end
    self
  end

  def ordered(field, direction = :asc)
    search.build do
      order_by(Child.sortable_field_name(field), direction) if !field.nil?
    end
    self
  end

  def created_by(user)
    search.build do
      with :created_by, user.user_name
    end
    self
  end

  def marked_as(field_to_filter)
    search.build do
      with(field_to_filter.to_sym, true) if field_to_filter and !field_to_filter.empty?
    end
    self
  end

  def fulltext_by(field_names=[], value=nil)
    search.build do
      fulltext value, fields: field_names.map(&:to_sym)
    end if value.present?
    self
  end

  def filter_by(field_name, value)
    search.build do
      with field_name.to_sym, value
    end if value.present?
    self
  end

  private

  def search
    @search ||= Sunspot.new_search(Child)
  end
end
