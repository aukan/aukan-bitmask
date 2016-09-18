aukan-bitmask
=============

Agnostic Bitmask Attribute

# Installation

``` sh
gem install aukan-bitmask
```

# Bitmask

Usage:

```rb
flags = Bitmask.new({
  :bit_ids => [:flag1, :flag2, :flag3],
  :value => 0
})

# Setting the value of a bit
flags.set :flag2, true

flags.get :flag1 # false
flags.get :flag2 # true
flags.get :flag3 # false

flags.value         # 2
flags.value.to_s(2) # "10"
```

Reseting the mask value:

```rb
flags.value = 5

flags.get :flag1 # true
flags.get :flag2 # false
flags.get :flag3 # true
```

Changing the bit ids:

```rb
flags.value = 5

flags.bit_ids = [:flag1, :flag3, :flag2]  # Switching flag2 for flag3

flags.get :flag1 # true
flags.get :flag2 # true
flags.get :flag3 # false
```

# BitmaskAttribute

Uses Bitmask to decorate a class attribute. Can be used on ActiveRecord or any ORM.

Usage:

```rb
class Something
  attr_accessor :flags

  include BitmaskAttribute
  bitmask_attribute :flags, {
    :bit_ids => [
      :flag1, :flag2, :flag3
    ],
    :default_value => 3
  }
end

algo = Something.new
algo.flags_bitmask.set(:flag1, false)

algo.flags_bitmask.get(:flag1) # false
algo.flags_bitmask.get(:flag2) # true
```

To add accessor methods for each flag (`flag1`/`flag1?`/`flag1=`) pass the option `:accessors => true`.
