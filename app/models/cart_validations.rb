module CartValidations
  def validate_dates
    # run on date change, 2 queries
    errors = []
    # blackouts not on date
    relevant_blackouts = Blackout.hard.for_2dates(self.start_date,self.due_date)
    errors << "A reservation cannot start on #{self.start_date}" if relevant_blackouts.for_date(self.start_date).count > 0
    errors << "A reservation cannot start on #{self.due_date}" if relevant_blackouts.for_date(self.due_date)
    errors << "This user has overdue reservations that prevent him/her from creating new ones" if Reservation.for_reserver(self.reserver_id).overdue.count > 0
    # for some reason reserver is submitted at the same time as dates
    return errors
  end

  def validate_items
    # run when items are added or removed, 1 query
    errors = []
    relevant = Reservation.for_reserver(self.reserver_id).not_returned
    category = Hash.new
    models = self.get_items
    # check if under max model count while simultaneously building a category hash
    self.items.each do |em_id, quantity|
      model = models.find(em_id)
      max_models = model.maximum_per_user
      self.start_date.to_date.upto(self.due_date.to_date) do |d|
        if relevant.overlaps_with_date(d).for_eq_model(model).count + quantity > max_models
          errors << "Cannot reserve more than #{max_models} #{model.name.pluralize}"
          break
        end
      end

      if category.include?(model.category)
        category[model.category] += quantity
      else
        category[model.category] = quantity
      end

    end

    # check if under max category count
    category.each do |cat, q|
      max_cat = cat.maximum_per_user
      self.start_date.to_date.upto(self.due_date.to_date) do |d|
        count = 0
        relevant.overlaps_with_date(d).each do |r|

          count += 1 if r.equipment_model.category == cat
        end
        if count + q > max_cat
          errors << "Cannot reserve more than #{max_cat} #{cat.name.pluralize}"
          break
        end
      end
    end
    return errors

  end

  def validate_dates_and_items
    # validations that run on both item and date changes
    # 1 query
    user_reservations = Reservation.for_reserver(self.reserver_id).checked_out
    errors = []
    models = self.get_items
    self.items.each do |item, quantity|

      model = models.find(item)

      # check availability
      errors << "#{model.name.titleize} is not available for the given time range" if model.num_available(self.start_date, self.due_date) < quantity

      # check maximum checkout length
      max_length = model.category.max_checkout_length
      max_length = Float::INFINTIY if max_length == 'unrestricted'
      errors << "#{model.name.titleize} can only be reserved for #{max_length} days" if self.duration > max_length

      # if a reservation should be renewed instead of checked out
      user_reservations.for_eq_model(model).each do |r|
        errors << "#{model.name.titleize} should be renewed instead of re-checked out"  if r.due_date == self.start_date && r.is_eligible_for_renew?
      end
    end
    return errors
  end

  def validate_all
    errors = validate_dates
    errors.concat(validate_items.to_a).concat(validate_dates_and_items.to_a)
    return errors
  end
end
