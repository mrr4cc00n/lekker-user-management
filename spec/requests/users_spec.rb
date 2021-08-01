require 'swagger_helper'

RSpec.describe 'users', type: :request do

  let(:user) do
    User.create(
      email: 'test@example.com',
      password: 's3cr3t',
      password_confirmation: 's3cr3t',
      )
  end

  let(:status) { 'archived' }

  path '/users/change_status' do

    post('change_status user') do
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authentication', :in => :header, :type => :string
      parameter name: 'data', :in => :body, schema: {
        type: :object,
        attributes: {
          user_id: { type: :integer },
          status: { type: :string }
        },
        required: [ 'user_id', 'status' ]
      }
      response(200, 'successful') do
        let(:'data') { { user_id: 1, status: status } }
        let(:'Authentication') { 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.JC6qKuH9SG0SIiYSfhZUFTtirxN9Q47buLk0DPFFFzE' }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
          p example
        end
        run_test!
      end
    end
  end

  path '/users' do

    get('list users') do
      produces 'application/json'
      parameter name: :status, :in => :path, :type => :string
      parameter name: 'Authentication', :in => :header, :type => :string
      response(200, 'successful') do
        let(:'Authentication') { token }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
          p example
        end
        run_test!
      end
    end
  end
end
