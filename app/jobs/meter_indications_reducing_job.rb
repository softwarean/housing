class MeterIndicationsReducingJob
  @queue = :meter_indications_reducing

  class << self
    def perform
      Services::MeterIndicationsReducer.process
    end
  end
end
