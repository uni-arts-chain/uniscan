require "tracker"

Tracker::logger = Logger.new(STDOUT)
Tracker::logger.level = Logger::DEBUG

desc "Track pangolin NFTs"
task :pangolin, [:block_number] => [:environment] do |t, args|
  begin
    start_from = Integer(args[:block_number])

    # init client and nft helper
    pangolin = Pangolin.new("wss://pangolin-rpc.darwinia.network")
    nft_helper = SubstrateEvmNftHelper.new(pangolin)
    contract_helper = PangolinContractHelper.new

    nft_helper.track_nft(start_from) do |erc721_events, erc1155_events|
      # TODO: send to sidekiq queue

      erc721_events.each do |erc721_event|
        begin
          name, symbol = contract_helper.get_name_and_symbol(erc721_event[:address])
          token_uri = contract_helper.get_token_uri(erc721_event[:address], erc721_event[:token_id])
          Tracker.logger.debug "name: #{name}, symbol: #{symbol}, token_uri: #{token_uri}, #{erc721_event}" 
          # ProcessErc721EventWorker.perform_async(
          #   blockchain: "Pangolin",
          #   block_number: 13110991,
          #   address: "0xa56a4f2b9807311ac401c6afba695d3b0c31079d",
          #   transaction_hash: "0x75ff6792387f250b4a47677ffd13bbe3ae79fef6a3be41a51fda1d4a8234bee7",
          #   from: "0x4c721c77190a44d640ff55be2699fe80a18ae730",
          #   to: "0x63141638f37c77e4ad0189b76d02607a0c80a1e7",
          #   token_id: "1544",
          #   token_uri: "https://api.monsterblocks.io/metadata/1544",
          #   name: "MonsterBlocks",
          #   symbol: "MONSTERBLOCK",
          # )

        rescue => ex
          Tracker.logger.error ex.message
          # Tracker.logger.error ex.backtrace
        end
      end

      erc1155_events.each do |erc1155_event|
        begin
          uri = contract_helper.get_uri(erc1155_event[:address], erc1155_event[:token_id])
          Tracker.logger.debug "uri: #{uri}, #{erc1155_event}" 
        rescue => ex
          Tracker.logger.error ex.message
          # Tracker.logger.error ex.backtrace
        end
      end

    end

  rescue ArgumentError => ex
    if ex.message.start_with?("invalid value for Integer")
      puts "Please input an integer as the block number."
      puts "Usage: rails \"pangolin[BLOCK_NUMBER>]\""
    end
  rescue => ex
    Tracker.logger.error ex.message
    # Tracker.logger.error ex.backtrace
  end
end
