class Application < Merb::Controller
    def convert_twit_time(s)
      year,mon,day,hr,min,sec,offset,zone=ParseDate::parsedate(s)
      "#{year}-#{mon}-#{day} #{hr}:#{min}:#{sec}"
    end
end
