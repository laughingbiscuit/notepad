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
  @host = "http://localhost"
  stdout, stderr, status = Open3.capture3("docker run -p 80:80 kennethreitz/httpbin && sleep 2")
  expect(status.success?).to be true
end
Given('I set {word} header to {word}') do |k, v|
  @cmdsnip += " -H \"#{k}:#{v}\""
end
When('I GET {}') do |path|
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

###
# Docker steps
###
Given('I run an nginx daemon in docker') do
  stdout, stderr, status = Open3.capture3("docker run -itd -p 8080:8080 nginx && sleep 1")
  attach(stdout, 'text/plain')
  expect(status.success?).to be true
end
When('I call nginx') do
  stdout, stderr, status = Open3.capture3("curl -isSL http://localhost:8080 2>&1")
  @prevResult = stdout
  attach(stdout, 'text/plain')
  expect(status.success?).to be true
end
Then('response body should contain {}') do |text|
  expect(@prevResult).to include(text)
end
