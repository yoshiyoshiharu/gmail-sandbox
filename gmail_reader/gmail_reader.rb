require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
CREDENTIALS_PATH = 'credentials.json'
TOKEN_PATH = 'token.yaml'
SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_READONLY

def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)

  if credentials.nil?
    puts "ブラウザで以下のURLを開いて認証コードを取得してください:"
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts url
    print "認証コードを入力: "
    code = gets.chomp
    credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

def list_messages(service, user_id = 'me', max_results = 1)
  result = service.list_user_messages(user_id, max_results: max_results)
  messages = result.messages || []
  
  if messages.empty?
    puts "メールが見つかりませんでした。"
  else
    messages.each do |message|
      msg = service.get_user_message(user_id, message.id)
      subject = msg.payload.headers.find { |h| h.name == 'Subject' }&.value
      from = msg.payload.headers.find { |h| h.name == 'From' }&.value
      parts = msg.payload.parts || []

      puts "\n-----"
      puts "From: #{from}"
      puts "Subject: #{subject}"
      pp parts
    end
  end
end
service = Google::Apis::GmailV1::GmailService.new
service.authorization = authorize

list_messages(service)
