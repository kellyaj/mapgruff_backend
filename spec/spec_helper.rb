require 'incident_creator'
require 'incident_monger'
require 'webmock/rspec'

TEST_DB_SETUP = YAML.load_file('config/test_db_setup.yml')

RSpec.configure do |config|
  DataMapper.setup(:default, TEST_DB_SETUP)
  DataMapper.finalize
  DataMapper.auto_upgrade!
  [:all, :each].each do |x|
    config.before(x) do
      repository(:default) do |repository|
        transaction = DataMapper::Transaction.new(repository)
        transaction.begin
        repository.adapter.push_transaction(transaction)
      end
    end

    config.after(x) do
      repository(:default).adapter.pop_transaction.rollback
    end
  end
end
