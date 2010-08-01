require 'open-uri'
require 'rexml/document'

class Run < ActiveRecord::Base
  @@user_id = "1350248965"
  
  def self.get_run
    run_id = "1615403977"
    url = "http://nikerunning.nike.com/"
    url << "nikeplus/v1/services/app/get_run.jsp"
    url << "?id=#{run_id}&userID=#{@@user_id}"
    result = ''
    open(url) do |f|
      doc = REXML::Document.new f.read
      doc.elements.each("plusService/sportsData/runSummary/*") do |el|
        result << el.name + ' ' + el.text + "<br />"
      end
    end
    result
  end

  def calculate_avg_pace
    self.avg_pace = duration_in_minutes / distance_in_miles
  end

  def duration_in_minutes
    #maybe make this a virtual attribute?
    duration / (60.0 * 1000)
  end

  def distance_in_miles
    distance * 0.62
  end

  def self.populate_runs
    attributes = {
     #:attr         #xml tagname
      :distance   => "distance",
      :start_time => "startTime",
      :duration   => "duration",
      :calories   => "calories"
    }
    
    all_runs_url = "http://nikerunning.nike.com/nikeplus/" +
      "v1/services/app/run_list.jsp?userID=#{@@user_id}"
    open(all_runs_url) do |f|
      doc = REXML::Document.new f.read
      doc.elements.each("plusService/runList/run") do |run_info|
        run_id = run_info.attributes["id"]
        run = find_or_initialize_by_run_id(run_id)

        attributes.each do |key, value|
          run.write_attribute(key, run_info.elements[value].text)
        end

        run.calculate_avg_pace
        run.save
      end
    end
  end
end
