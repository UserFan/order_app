module Helpers
  def rating_for_avg(rateable_obj, dimension=nil, options={})

    cached_average = rateable_obj.average dimension
    avg = cached_average ? cached_average.avg : 0

    star         = options[:star]         || 5
    enable_half  = options[:enable_half]  || false
    half_show    = options[:half_show]    || true
    star_path    = options[:star_path]    || "/assets"
    star_on      = options[:star_on]      || "star-on.png"
    star_off     = options[:star_off]     || "star-off.png"
    star_half    = options[:star_half]    || "star-half.png"
    cancel       = options[:cancel]       || false
    cancel_place = options[:cancel_place] || "left"
    cancel_hint  = options[:cancel_hint]  || "Cancel current rating!"
    cancel_on    = options[:cancel_on]    || "cancel-on.png"
    cancel_off   = options[:cancel_off]   || "cancel-off.png"
    noRatedMsg   = options[:noRatedMsg]   || "I'am readOnly and I haven't rated yet!"
    # round        = options[:round]        || { down: .26, full: .6, up: .76 }
    space        = options[:space]        || false
    single       = options[:single]       || false
    target       = options[:target]       || ''
    targetText   = options[:targetText]   || ''
    targetType   = options[:targetType]   || 'hint'
    targetFormat = options[:targetFormat] || '{score}'
    targetScore  = options[:targetScore]  || ''

    disable_after_rate = options[:disable_after_rate] && true
    disable_after_rate = true if disable_after_rate == nil

    if options[:imdb_avg] && disable_after_rate && avg > 0
      content_tag :div, '', :style => "background-image:url(/assets/mid-star.png);width:61px;height:51px;" do
          content_tag :p, avg, :style => "position:relative;font-size:.8rem;text-align:center;line-height:60px;"
    end
    end
  end
end
