Ransack.configure do |config|
  config.add_predicate 'ig_case', # Name your predicate
    arel_predicate: 'matches',
    formatter: proc { |v| "%#{v.to_s.gsub(/([\\|\%|.])/, '\\\\\\1').mb_chars.upcase}%"},
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string
end
