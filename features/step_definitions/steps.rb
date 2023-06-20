require 'open3'

When('I have a passing test') do
end

When('I say hello') do
  stdout, stderr, status = Open3.capture3('sh notepad.sh say_hello 2>&1')
  attach(stdout, 'text/plain')
  expect(status.success?).to be true
end

###
# API
###

Before do |scenario|
  @cmdsnip = ""
  @host = "https://httpbin.org"
end
Given('I set {word} header to {word}') do |k, v|
  @cmdsnip += " -H \"#{k}:#{v}\""
end
When('I GET {word}') do |path|
  cmd = "curl -isSL #{@host}#{path} #{@cmdsnip}' 2>&1"
  attach(cmd, 'text/plain')
  stdout, stderr, status = Open3.capture3(cmd)
  @prevResult = stdout
  attach(stdout, 'text/plain')
  expect(status.success?).to be true
end
Then('response code should be {word}') do |code|
  actual = @prevResult.lines.first.split[1]
  expect(code).to eq(actual)
end
