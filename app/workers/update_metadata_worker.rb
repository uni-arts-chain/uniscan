class UpdateMetadataWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'update_metadata_events', retry: false

  def perform(token_id)
    token = Token.find(token_id)
    
    if token
      token.process_token_uri
    end
  end
end
