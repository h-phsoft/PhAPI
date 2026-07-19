class ResultManager {
  static ok(data) {
    return {
      success: true,
      data: data || null,
      message: 'Success',
      timestamp: new Date().toISOString()
    };
  }

  static invalid(message) {
    return {
      success: false,
      data: null,
      message: message || 'Invalid request',
      timestamp: new Date().toISOString()
    };
  }

  static error(message, code) {
    return {
      success: false,
      data: null,
      message: message || 'Error occurred',
      code: code || 500,
      timestamp: new Date().toISOString()
    };
  }

  static success(message) {
    return {
      success: true,
      data: null,
      message: message || 'Operation successful',
      timestamp: new Date().toISOString()
    };
  }
}

module.exports = ResultManager;