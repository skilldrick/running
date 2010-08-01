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

  def self.get_all_runs
    
    result = ''
    open(all_runs_url) do |f|
      doc = REXML::Document.new f.read
      doc.elements.each("plusService/runList/run") do |run|
        result << run.elements["distance"].text + "<br />"
      end
      result
    end
  end
    
  def self.populate_runs
    all_runs_url = "http://nikerunning.nike.com/nikeplus/" +
      "v1/services/app/run_list.jsp?userID=#{@@user_id}"
    open(all_runs_url) do |f|
      doc = REXML::Document.new f.read
      doc.elements.each("plusService/runList/run") do |run_info|
        run_id = run_info.attributes["id"]
        run = find_or_initialize_by_run_id(run_id)
        run.distance = run_info.elements["distance"].text
        run.save
      end
    end
  end
end
