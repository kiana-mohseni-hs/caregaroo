var StringUtilities = function () {
  function randomString(chars, length) {
    var string = "";
    for (x = 0; x < length; x++) {
      i = Math.floor(Math.random() * chars.length);
      string += chars.charAt(i);
    }
    return string;
  }

  return {
    randomAlphaString: function (length) {
      chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
      return randomString(chars, length);
    },
    randomAlphaNumericString: function (length) {
      chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
      return randomString(chars, length);
    },
    randomNumericString: function (length) {
      chars = "1234567890";
      return randomString(chars, length);
    },
    randomEmailString: function (length) {
      chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      return randomString(chars, length) + "@" + randomString(chars, length) + ".com";
    }
  }
} ();
