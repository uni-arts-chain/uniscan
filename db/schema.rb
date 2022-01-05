# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_05_031251) do

  create_table "accounts", charset: "utf8mb4", force: :cascade do |t|
    t.string "address"
    t.integer "blockchain_id"
    t.integer "level", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address", "blockchain_id"], name: "index_accounts_on_address_and_blockchain_id", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blockchains", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.boolean "testnet", default: false
    t.string "explorer_token_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "explorer_address_url"
  end

  create_table "collections", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.integer "blockchain_id"
    t.integer "contract_platform", default: 0
    t.string "contract_address"
    t.integer "nft_type", default: 0
    t.decimal "total_supply", precision: 65
    t.integer "holders_count", default: 0
    t.integer "transfers_count", default: 0
    t.integer "creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "supply", precision: 65, default: "0"
    t.string "creator_address"
    t.integer "created_at_block"
    t.integer "created_at_timestamp"
    t.string "created_at_tx"
    t.index ["contract_address"], name: "index_collections_on_contract_address", unique: true
  end

  create_table "continuations", charset: "utf8mb4", force: :cascade do |t|
    t.string "last"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "nfts", charset: "utf8mb4", force: :cascade do |t|
    t.string "contract"
    t.string "token_id"
    t.text "token_uri"
    t.text "metadata"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "properties", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "value"
    t.integer "token_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "token_ownerships", charset: "utf8mb4", force: :cascade do |t|
    t.integer "token_id"
    t.integer "account_id"
    t.decimal "balance", precision: 65, default: "1"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "collection_id"
    t.index ["account_id", "token_id"], name: "index_token_ownerships_on_account_id_and_token_id", unique: true
  end

  create_table "tokens", charset: "utf8mb4", force: :cascade do |t|
    t.string "token_id_on_chain"
    t.integer "collection_id"
    t.boolean "unique", default: true
    t.decimal "supply", precision: 65, default: "1"
    t.integer "owner_id"
    t.text "name"
    t.text "description"
    t.text "image_uri"
    t.text "token_uri"
    t.boolean "ipfs", default: false
    t.integer "transfers_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "holders_count", default: 0
    t.text "token_uri_err"
    t.boolean "token_uri_processed", default: false
    t.integer "transfers_count_24h", default: 0
    t.integer "transfers_count_7d", default: 0
    t.datetime "last_transfer_time"
    t.string "image_ori_content_type"
    t.integer "image_size", default: 0
  end

  create_table "transfers", charset: "utf8mb4", force: :cascade do |t|
    t.integer "collection_id"
    t.integer "token_id"
    t.decimal "amount", precision: 65, default: "1"
    t.integer "from"
    t.integer "to"
    t.integer "block_number"
    t.string "txhash"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "contract_address"
    t.string "token_id_on_chain"
    t.index ["contract_address", "token_id_on_chain", "from", "to", "txhash"], name: "transfers_uniq_index2", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
