class ResultManager {
  static ok(dataOrMessage, data) {
    if (typeof dataOrMessage === 'string' && data !== undefined) {
      return {
        status: true,
        code: 200,
        message: dataOrMessage,
        data: data || {}
      };
    }
    if (typeof dataOrMessage === 'string') {
      return {
        status: true,
        code: 200,
        message: dataOrMessage,
        data: {}
      };
    }
    return {
      status: true,
      code: 200,
      message: 'Success',
      data: dataOrMessage !== undefined && dataOrMessage !== null ? dataOrMessage : {}
    };
  }

  static invalid(message) {
    return {
      status: false,
      code: 404,
      message: message || 'Invalid Request',
      data: {}
    };
  }

  static error(code, message) {
    const numericCode = typeof code === 'number' ? code : 400;
    const msg = typeof code === 'string' ? code : message;
    return {
      status: false,
      code: numericCode,
      message: msg || 'Error occurred',
      data: {}
    };
  }

  static success(message) {
    return {
      status: true,
      code: 200,
      message: message || 'Operation successful',
      data: {}
    };
  }

  static welcome(message, token, data = {}) {
    return {
      status: true,
      code: 200,
      message: message || 'Welcome',
      token: token || '',
      data: data || {}
    };
  }

  static invalidLogin(message) {
    return {
      status: false,
      code: 401,
      message: message || 'Invalid login or password',
      token: '',
      data: {}
    };
  }
}

module.exports = ResultManager;