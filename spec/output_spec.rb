require 'automate_api'

describe AutomateApi::Output do
  context 'default' do
    it 'should not print debug' do
      expect { AutomateApi::Logger.debug('test') }.to_not output(/test/).to_stdout
    end

    it 'should print info' do
      expect { AutomateApi::Logger.info('something or other') }.to output(/INFO/).to_stdout
    end

    it 'should print warn' do
      expect { AutomateApi::Logger.warn('warning!') }.to output(/WARN/).to_stdout
    end

    it 'should print formatted output' do
      expect { AutomateApi::Logger.display('type', 'message') }.to output(/\[TYPE\] message/).to_stdout
    end
  end

  context 'with debug enabled' do
    it 'should print debug' do
      AutomateApi::Config.debug = true
      expect { AutomateApi::Logger.debug('test') }.to output(/test/).to_stdout
    end

    it 'should find a logger on root module' do
      expect { AutomateApi.logger.error('test error output') }.to output(/test error output/).to_stdout
    end
  end
end
