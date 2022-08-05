# Sieves

Ruby gem and JS package including filtering tools with GUI for rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "sieves"
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install sieves
```

Pin the associated JS package:

```shell
bin/importmap pin sieves-js
```

Add this to app/javascript/controllers/index.js:

```js
// app/javascript/controllers/index.js
// ...
import * as sieves from "sieves-js"
sieves.controllersRegistration(application)
```

## Usage

Configure the model:

```ruby
class Book
  include Filterable # Add this line

  has_one :author # ...

  # AFTER ASSOCIATIONS:
  filterable do
    # add several filterable columns at once
    columns :title, :summary

    # add one filterable column to specify formatter
    # formatter is called before passing user input to filter
    column :total_amount_cents, input_formatter: proc { |value| Money.from_amount(value).cents }

    # the label_method is used for display in the select list
    association :author, label_method: :full_name

    # a scope can be passed to be used for the select list
    association :author, label_method: :full_name, select_scope: -> { where(featured: true) }
    # can be either lambda or symbol
    association :author, label_method: :full_name, select_scope: :featured_authors

    # if you want to filter on the column from an association
    # (N.B: you can also provide an input_formatter)
    associated_column :last_name, from: :author
  end
end
```

Next, in the view, where you want to display the filters:

```erb
<%= filterable_form_for(Book) %>
```

In the controller:

```ruby
# NB: if there are no submitted filters, this simply returns `Book.all`
@books = filterable(Book)

# you can also pass a base relation like this:
@books = fitlerable(Book, books.where(promotion: true))

# you can then chain this with other query methods:
@books = @books.
    includes(author: { avatar_attachment: :blob }).
    includes(reviews: [:summary, :content]).
    order("reviews.created_at DESC").
    with_attached_cover_image
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
