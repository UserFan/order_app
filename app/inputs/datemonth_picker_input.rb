class DatemonthPickerInput < DatePickerInput
  private

  def display_pattern
    I18n.t('datepicker.dformat', default: '%m/%Y')
  end

  def picker_pattern
    I18n.t('datepicker.dformat', default: 'MM/YYYY')
  end

  def date_options_base
    {
        locale: I18n.locale.to_s,
        format: picker_pattern,
        viewMode: 'months',
        dayViewHeaderFormat: date_view_header_format
    }
  end
end
