require 'automate_api'

describe AutomateApi::Resource::Base do
  context 'default' do
    class TestResource < AutomateApi::Resource::Base
      endpoints create: { path: 'test', method: :post },
                foo: { path: 'foo', method: :post },
                all: { path: 'all', collect: 'all' },
                find: { path: 'find/{{id}}', alias: :fetch }
    end

    let(:success_response) {
      response = double
      allow(response).to receive(:success?).and_return(true)
      allow(response).to receive(:code).and_return(200)
      allow(response).to receive(:message).and_return('OK')
      allow(response).to receive(:parsed_response).and_return({ name: 'test'})
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

      it 'should not raise error on method_missing request' do
        expect(TestResource).to receive(:method_missing)
          .with(:foo).and_call_original

        expect(AutomateApi::Client).to receive(:post)
          .with('/api/v0/foo', request_opts).and_return(success_response)

        expect{ TestResource.foo }.to_not raise_error
      end

      it 'should raise error on method_missing request' do
        expect(TestResource).to receive(:method_missing)
          .with(:foo).and_call_original

        expect(AutomateApi::Client).to receive(:post)
          .with('/api/v0/foo', request_opts).and_return(fail_response)

        expect{ TestResource.foo }.to raise_error(AutomateApi::RequestError)
      end

      it 'should raise method not found error' do
        expect{ TestResource.no_method_name }.to raise_error(NoMethodError)
      end

      it 'should create a new reource' do
        opts = request_opts.merge(body: { name: 'box' }.to_json)

        expect(AutomateApi::Client).to receive(:post)
          .with('/api/v0/test', opts).and_return(success_response)

        test = TestResource.create({ name: 'box' })
        expect(test).to be_a TestResource
      end

      it 'should try to fetch data' do
        expect(AutomateApi::Client).to receive(:get)
          .with('/api/v0/find/box', request_opts).and_return(success_response)

        test = TestResource.initialize_or_find('box')
        expect(test).to be_a(TestResource)
        expect(test.attributes).to eq({ 'name' => 'test' })
      end

      let(:multi_response) {
        response = double
        allow(response).to receive(:success?).and_return(true)
        allow(response).to receive(:code).and_return(200)
        allow(response).to receive(:message).and_return('OK')
        allow(response).to receive(:parsed_response)
          .and_return({ all: [{ name: 'test1'}, { name: 'test2' }] })

        response
      }

      it 'should fetch multiple results' do
        expect(AutomateApi::Client).to receive(:get)
          .with('/api/v0/all', request_opts).and_return(multi_response)

        results = TestResource.all

        expect(results.count).to eq 2
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
        expect{ instance.update }.to raise_error AutomateApi::Resource::EndpointNotSupported
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

        expect{ instance.foo }.to raise_error(AutomateApi::RequestError)
      end

      it 'should return the value of an attribute' do
        expect(instance.name).to eq 'test'
      end

      it 'should raise method not found error' do
        expect{ instance.no_method_name }.to raise_error(NoMethodError)
      end
    end

  end
end
