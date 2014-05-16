require 'ruby-jmeter'

test do

  with_json

  threads 1, loops: 1 do
    get   name: 'get_products_index',
          url: 'http://example-rest-api.herokuapp.com/api/products'

    post  name: 'create_new_product',
          url: 'http://example-rest-api.herokuapp.com/api/products',
          fill_in: {
            product: {
              name: "Thomas the Tank Engine",
              price: "100.0"
            }
          }

    console_status_logger
  end

end.run(path: '/usr/share/jmeter-2.11/bin/', debug: true)
