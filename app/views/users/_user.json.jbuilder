json.extract! user, :id, :nickname, :password, :number, :name, :birth_day, :created_at, :updated_at
json.url user_url(user, format: :json)
