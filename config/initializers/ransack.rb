Ransack.configure do |config|
  config.add_predicate 'ig_case', # Name your predicate
    arel_predicate: 'matches',
    formatter: proc { |v| "%#{v.to_s.gsub(/([\\|\%|.])/, '\\\\\\1').mb_chars.upcase}%"},
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string
end

Ransack.configure do |c|
  c.custom_arrows = {
    up_arrow: '<i class="fa fa-sort-amount-up"></i>',
    down_arrow: '<i class="fa fa-sort-amount-down"></i>',
    default_arrow: '<i class="default-arrow-icon"></i>'

  }
end
