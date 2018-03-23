RSpec.shared_context 'relations' do
  include_context 'database'

  before do
    conn.extension(:pg_range)
    conn.create_table(:users) do
      primary_key :id
      column :last_name, String, null: false
      column :first_name, String, null: false
      column :email, String, null: false
      column :created_at, Time, null: false
      column :updated_at, Time, null: false
      column :age, Integer
    end

    conn.create_table(:tasks) do
      primary_key :id
      foreign_key :user_id, :users
      column :title, String, null: false
    end

    conn.create_table(:announcements) do
      primary_key :id
      numrange :when, null: false
      column :begin, Integer, null: false
      column :end, Integer, null: false
    end

    conf.relation(:announcements) do
      schema(infer: true)
    end

    conf.relation(:tasks) do
      schema(infer: true) do
        associations do
          belongs_to :user
        end
      end
    end

    conf.relation(:users) do
      schema(infer: true) do
        associations do
          has_many :tasks
        end
      end
    end
  end

  after do
    conn.drop_table(:tasks)
    conn.drop_table(:users)
    conn.drop_table(:announcements)
  end
end
