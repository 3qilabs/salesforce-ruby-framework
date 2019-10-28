def rand_string_alpha(length, save_as = nil)
  chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ'
  result = Array.new(length) {chars[rand(chars.length)].chr}.join
  current_test.test_params[save_as] = result if save_as
  result
end