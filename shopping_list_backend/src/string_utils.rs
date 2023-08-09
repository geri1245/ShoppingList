// pub fn add_to_string_with_wrapping_characters(
//     original_string: &mut String,
//     string_to_append: &str,
//     left_wrap: &str,
//     right_wrap: &str,
// ) {
//     original_string.reserve(
//         original_string.len() + string_to_append.len() + left_wrap.len() + right_wrap.len(),
//     );

//     original_string.push_str(left_wrap);
//     original_string.push_str(string_to_append);
//     original_string.push_str(right_wrap);
// }

// pub fn append_as_string(original_string: &mut String, string_to_append: &str) {
//     add_to_string_with_wrapping_characters(original_string, string_to_append, "\"", "\"");
// }
