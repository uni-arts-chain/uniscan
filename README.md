# README

Uniscan is a NFT Explorer for blockchains.

## Dependences

1. Ruby
2. Ruby on Rails - Web framework
3. [Hotwire](https://hotwired.dev/) - An alternative approach to building modern web applications 
4. MySQL
5. Redis
5. ImageMagick - Convert image, resize image, identify image
6. FFmpeg - Convert video to gif
7. [Alibabacloud OSS](https://www.alibabacloud.com/product/oss) - Online image storage and access service
8. [Sidekiq](https://sidekiq.org/) - Simple, efficient background processing for Ruby

## Architecture and components

![arch](https://snz04pap002files.storage.live.com/y4mIiJvN7g7-MQnj_eP4EjEgmSi2Q8yiR7ZZ2ERg3iGfs98xbdFq9pw__ozpWSHpaAy0XGW6ub3yOvFn6eqncPntrIwya-TzklUOrmtnkRI6DfhoDcNkZpG1XT-f8VF5S6Ag8krwn-4RwmN1YGJhmQhPhIiJvOwLXBFwh9uubcZgwqPG887WRJ9dcXjpsUg8C7k?width=591&height=611&cropmode=none)

### Web Server  
Provide web pages for users to use.

### NFT trackers for blockchains  
Track and get the NFT on the blockchains.   
There are now trackers for Ethereum and Darwinia as examples.

### NFT Workers  
A NFT worker is a long-running process.  
It is responsible for collecting the NFT discovered by the tracker and storing it in the database.  
The data from the tracker is packaged into a `sidekiq` message for delivery.  

### NFT token_uri processor        
It reads the token_uri of NFT from the database, and then obtains the metadata.   
And, it will download and process the image from the metadata.

## Models
A model is a Ruby class that is used to represent data. 
Additionally, models can have most of the application's logic.

1. {Account}
2. {Blockchain}
3. {Collection}
4. {Token}
5. {Property}
6. {TokenOwnership}
7. {Transfer}

The relationship between the models:

![relationship](https://snz04pap002files.storage.live.com/y4m5pmLclQaV3Wn6M_am93oL4rDxrXdJduxHz7vav-6iPgaIwIOv679KqaDfPnR8SKG8l-Tn4oV7YNtpmsbJ678Di__1Z5zp45-zBMG1dkinTBCCd_IlrTC40VoYv8G4w5G3_s0fexofUtdMEi72tEzXiTpaiR_PFmKbwnKnuKhawvZ-SfW1EMbHUDFglzyeGqq?width=838&height=359&cropmode=none)

## Controllers
Controllers handle the incoming web requests and eventually respond with a rendered view.

1. {WelcomeController}
2. {TokensController}
3. {CollectionsController}
4. {AccountsController}

## Test

### Preparation

1. Install Ruby ~> 2.7.0  
   See [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/)
  
2. Install ImageMagick & FFmpeg  

3. Download code  
   Download or clone the [code](https://github.com/uni-arts-chain/uniscan) to local, and go to the root directory.

4. Install Rubygems

    ```bash
    bundle install
    ```

### Run all tests

```bash
rails test
```

### Run a single test file

```bash
rails test test/models/transfer_test.rb
```

## Docker

### Run

### Test

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/uni-arts-chain/uniscan.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Supported by web3 foundation
![grants_badge](https://snz04pap002files.storage.live.com/y4mLxrj1EO2ik2j5eYT_w1u7aPsDivmGcngm27pLcvzNwApRMTawf8dvwMnl-Gtd5Y0GMVu8ddYUI_nZwBIXUzGLjZ3sU_9zSlvGXhpsXBGfDv__nuS-wOx2rbdpdMp52Umsd94t7vCQPP5PXjrBWjgoc83RIxLyyl7S3q_ZSOrrHz9bQ9RiSMQizMB07gUsol_?width=660&height=264&cropmode=none)

