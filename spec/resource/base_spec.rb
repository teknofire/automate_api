require 'automate_api'

describe AutomateApi::Resource::Base do
  before do
    AutomateApi::Config.reset
    AutomateApi::Config.ssl_verify = false
    AutomateApi::Config.automate_url = 'https://test.test'
    AutomateApi::Config.auth_token = 'test_token'
    AutomateApi.client.reload
  end

  context 'default' do
    class TestResource < AutomateApi::Resource::Base
      endpoints create: { path: 'test', method: :post },
                foo: { path: 'foo', method: :post }
    end

    it 'should set the attributes on new' do
      tr = TestResource.new({ name: 'test' })

      expect(tr.attributes).to match({ name: 'test' })
    end

    context 'class methods' do
      it 'should support create endpoint' do
        expect(TestResource.supports?(:create)).to eq true
      end

      it 'should not support delete endpoint' do
        expect(TestResource.supports?(:delete)).to eq false
      end

    end

    context 'instance methods' do
      let(:instance) { TestResource.new({ name: 'test' }) }

      it 'should support create endpoint' do
        expect(instance.supports?(:create)).to eq true
      end

      it 'should not support delete endpoint' do
        expect(instance.supports?(:delete)).to eq false
      end

      it 'should raise error on update' do
        expect{ instance.update }.to raise_error AutomateApi::EndpointNotSupported
      end

      let(:success_response) {
        response = double
        allow(response).to receive(:success?).and_return(true)
        allow(response).to receive(:code).and_return(200)
        allow(response).to receive(:message).and_return('OK')
        allow(response).to receive(:parsed_response).and_return({ name: 'test '})
        response
      }

      let(:fail_response) {
        response = double
        allow(response).to receive(:success?).and_return(false)
        allow(response).to receive(:code).and_return(400)
        allow(response).to receive(:message).and_return('Already exists')
        allow(response).to receive(:parsed_response).and_return({ error: 'Test already exists' })
        response
      }
      let(:request_opts) do
        {
          headers: {
            "api-token"=>"test_token",
            "content-type"=>"application/json"
          },
          verify: false
        }
      end

      it 'should not raise error on successful create' do
        expect(AutomateApi::Client).to receive(:post).and_return(success_response)
        expect{ instance.create }.to_not raise_error
      end

      it 'should raise error on failed create' do
        expect(AutomateApi::Client).to receive(:post).and_return(fail_response)
        expect{ instance.create }.to raise_error(AutomateApi::RequestError)
      end

      it 'should not raise error on method_missing request' do
        expect(instance).to receive(:method_missing)
          .with(:foo).and_call_original

        opts = request_opts.merge(body: { name: 'test' }.to_json)
        expect(AutomateApi::Client).to receive(:post)
          .with('/api/v0/foo', opts).and_return(success_response)

        expect{ instance.foo }.to_not raise_error
      end

      it 'should raise error on method_missing request' do
        expect(instance).to receive(:method_missing)
          .with(:foo).and_call_original

        opts = request_opts.merge(body: { name: 'test' }.to_json)
        expect(AutomateApi::Client).to receive(:post)
          .with('/api/v0/foo', opts).and_return(fail_response)

        # instance.foo
        expect{ instance.foo }.to raise_error(AutomateApi::RequestError)
      end
    end

  end
end
