require 'ruby-jmeter'

base_url = 'http://example-rest-api.herokuapp.com/api'
# base_url = 'http://127.0.0.1:3000/api'

# start a test
test do

  # make all requests with an Accept: application/json header
  with_json

  # start 1 user and loop 5 times
  threads 1000, loops: 1 do

    # make a HTTP GET request to the product index
    get name: 'list_products', url: "#{base_url}/products"

    # make a HTTP POST to create a new product
    post  name: 'create_product',
          url: "#{base_url}/products",
          fill_in: {
            "product[name]"        => 'Thomas the Tank Engine',
            "product[price]"       => 9.99,
            "product[released_on]" => Time.now,
            "product[category_id]" => 2
          } do
            # assert that the response code equals 201
            assert equals: '201', test_field: 'Assertion.response_code'

            # extract the product ID from the JSON response into ${product_id}
            extract name: 'product_id', regex: '"id":(\d+)'
    end

    # use the exists helper to make sure we have a product ID before continuing
    exists 'product_id' do

      # make a HTTP GET to show an individual product
      get name: 'show_product', url: "#{base_url}/products/${product_id}" do

        # assert that the name of the product is in the response body
        assert substring: 'Thomas the Tank Engine'
      end

      # make a HTTP PUT to edit an individual product
      put name: 'edit_product',
          raw_path: true,
          url: "#{base_url}/products/${product_id}?product[name]=Salty the Steam Engine&product[released_on]=#{Time.now}" do
            # assert that the response code equals 204
            assert equals: '204', test_field: 'Assertion.response_code'
      end

      # make a HTTP DELETE to delete an individual product
      delete name: 'delete_product', url: "#{base_url}/products/${product_id}" do
        # assert that the response code equals 204
        assert equals: '204', test_field: 'Assertion.response_code'
      end

    end

    # add a debug sampler, useful for spying on JMeter variables in the GUI. Disable for load testing.
    # debug_sampler

    # add some debugging information to the console using JMeter Plugins. Not required for Flood IO.
    # console_status_logger

    # add a view results tree listener for debugging in the GUI. Disable for load testing.
    # view_results
  end

# complete the test plan and run it locally with JMeter
# end.run(path: '/usr/share/jmeter-2.11/bin/', debug: true)

# OR

# run the same test plan on Flood IO
end.flood(ENV['FLOOD_API_TOKEN'], {
  name: 'Load Testing RESTful APIs with Ruby-JMeter',
  tag_list: 'rest',
  privacy_flag: 'public'})
