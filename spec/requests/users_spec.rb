require 'swagger_helper'

RSpec.describe 'users', type: :request do

  path '/users/change_status' do

    post('change_status user') do
      tags 'Users'
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
        let!(:user) do
          User.create(
            id: 1,
            email: 'test@example.com',
            password: 's3cr3t',
            password_confirmation: 's3cr3t',
            )
        end
        let!(:user2) do
          User.create(
            id: 2,
            email: 'test@example1.com',
            password: 's3cr3t',
            password_confirmation: 's3cr3t',
            )
        end
        let(:'data') { { user_id: user2.id, status: 'archived' } }
        let(:'Authentication') { 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.JC6qKuH9SG0SIiYSfhZUFTtirxN9Q47buLk0DPFFFzE' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['attributes']['status']).to eq('archived')
          puts data
        end
      end

      response(401, 'unauthorized') do
        let!(:user) do
          User.create(
            id: 1,
            email: 'test@example.com',
            password: 's3cr3t',
            password_confirmation: 's3cr3t',
            )
        end
        let(:'data') { { user_id: user.id, status: 'archived' } }
        let(:'Authentication') { 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.JC6qKuH9SG0SIiYSfhZUFTtirxN9Q47buLk0DPFFFzE' }
        run_test!
      end
    end
  end

  path '/users' do

    get('list users') do
      tags 'Users'
      produces 'application/json'
      parameter name: 'Authentication', :in => :header, :type => :string
      response(200, 'successful') do
        let!(:user) do
          User.create(
            id: 1,
            email: 'test@example.com',
            password: 's3cr3t',
            password_confirmation: 's3cr3t',
            )
        end
        let(:'Authentication') { 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.JC6qKuH9SG0SIiYSfhZUFTtirxN9Q47buLk0DPFFFzE' }
        run_test! do |response|
          data = JSON.parse(response.body)
          puts data
          expect(data['data'].size).to eq(1)
        end
      end
    end
  end
end
