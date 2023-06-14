require 'open3'

When('I have a passing test') do
end

When('I say hello') do
  stdout, stderr, status = Open3.capture3('sh notepad.sh say_hello 2>&1')
  attach(stdout, 'text/plain')
  expect(status.success?).to be true
end
