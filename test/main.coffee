require "should"

describe "mocha", ->
  it "should pass", ->
    1.should.eql 1
  it "should fail", ->
    1.should.eql 2
    
  