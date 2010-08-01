require 'open-uri'
require "rexml/document"

class Run < ActiveRecord::Base
  attr_reader :distance, :avg_pace
  
  def self.get_run
    user_id = "1350248965"
    run_id = "1615403977"
    all_runs_url = "http://nikerunning.nike.com/nikeplus/" +
      "v1/services/app/run_list.jsp?userID=#{user_id}"
    url = "http://nikerunning.nike.com/"
    url << "nikeplus/v1/services/app/get_run.jsp"
    url << "?id=#{run_id}&userID=#{user_id}"
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
    user_id = "1350248965"
    all_runs_url = "http://nikerunning.nike.com/nikeplus/" +
      "v1/services/app/run_list.jsp?userID=#{user_id}"
    result = ''
    open(all_runs_url) do |f|
      doc = REXML::Document.new f.read
      doc.elements.each("plusService/runList/run") do |run|
        result << run.elements["distance"].text + "<br />"
      end
      result
    end
  end
    
    
end
