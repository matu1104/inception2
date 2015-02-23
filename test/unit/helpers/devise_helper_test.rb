require 'test/unit'
require 'test_helper'
require 'mocha/test_unit'

class DeviseHelperTest < ActionView::TestCase

  # Added only to exist in class, after is overwriting by mocha module
  def resource
  end

  context 'devise_error_message!' do
    context 'when registration is successful' do
      setup do
        self.stubs(:resource).returns(stub(errors: []))
      end

      should 'return empty string' do
        assert_equal '', devise_error_message!
      end
    end

    context 'when registration fails' do
      setup do
        mock_full_messages = stub(full_messages: ['message'], empty?: false)
        mock_error = stub(errors:  mock_full_messages)
        self.stubs(:resource).returns(mock_error)
      end

      should 'return an error string' do
        assert_equal '<div class="alert alert-danger" id="error_explanation" role="alert"><ul><li>message</li></ul></div>',
                     devise_error_message!
      end
    end
  end

  context 'login_error_message!' do
    context 'login is successful' do
      setup do
        self.stubs(:flash).returns({})
      end

      should 'return empty string' do
        assert_equal '', login_error_message!
      end
    end

    context 'login is not successful' do
      setup do
        self.stubs(:flash).returns({ alert: 'message' })
      end

      should 'return an error string' do
        assert_equal '<div class="alert alert-danger" id="error_explanation" role="alert"><strong>Upss!! </strong>message</div>',
                     login_error_message!
      end
    end
  end
end