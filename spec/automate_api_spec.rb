require 'automate_api'

describe AutomateApi::Client do
  context 'defaults' do
    it 'should have a client' do
      expect(AutomateApi.client).to be_an(AutomateApi::Client)
    end

    it 'should fail to load configs' do
      expect{ AutomateApi.configure('file_should_not_exist') }
        .to output(/Could not find any config files, using defaults/).to_stdout
    end

  end

  context 'custom logger' do
    after do
      AutomateApi.logger = AutomateApi::Logger
    end

    it 'should let you specify your own logger' do
      class TestLogger
      end

      AutomateApi.logger = TestLogger

      expect(AutomateApi.logger).to eq TestLogger
    end
  end
end
