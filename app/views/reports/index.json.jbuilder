json.array!(@reports) do |report|
  json.extract! report, :id, :user_id, :body, :title, :date
  json.url report_url(report, format: :json)
end
