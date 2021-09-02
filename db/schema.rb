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

ActiveRecord::Schema.define(version: 2021_09_02_135016) do

  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "address"
    t.integer "blockchain_id"
    t.integer "level", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "blockchains", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "testnet", default: false
    t.string "explorer_base_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "collections", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.integer "blockchain_id"
    t.integer "contract_platform", default: 0
    t.string "contract_address"
    t.integer "nft_type", default: 0
    t.integer "total_supply"
    t.integer "holders_count", default: 0
    t.integer "transfers_count", default: 0
    t.integer "creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "supply", default: 0
  end

  create_table "token_ownerships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "token_id"
    t.integer "account_id"
    t.integer "balance", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "collection_id"
    t.index ["account_id", "token_id"], name: "index_token_ownerships_on_account_id_and_token_id", unique: true
  end

  create_table "tokens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "token_id_on_chain"
    t.integer "collection_id"
    t.boolean "unique", default: true
    t.integer "supply", default: 1
    t.integer "owner_id"
    t.string "name"
    t.string "description"
    t.string "image"
    t.text "token_uri"
    t.boolean "is_permanent"
    t.string "explorer_url"
    t.integer "transfers_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "holders_count", default: 0
  end

  create_table "transfers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "collection_id"
    t.integer "token_id"
    t.integer "amount", default: 1
    t.integer "from"
    t.integer "to"
    t.integer "block_number"
    t.string "txhash"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
