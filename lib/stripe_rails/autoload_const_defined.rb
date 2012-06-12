def Object.autoload_const_defined?(name)
  self.const_get name
ensure
  return self.const_defined?(name)
end