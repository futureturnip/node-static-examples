#extends.coffee
A = 
    name: "John"

B = 
    age: 12

C = 
    description: "I love CoffeeScript"

D = A extends B extends C

for prop, value of D 
    console.log "#{prop} = #{value}"