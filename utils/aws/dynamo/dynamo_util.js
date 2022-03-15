let params = {
    TableName: 'BandCloud_User',
    Item: {
      'Username' : {S: `'${}'`},
      'Email' : {S: `'${}'`},
      'Credentials': {M: {
          'Password': {S: `'${}'`},
          'Salt': {S: `'${}'`}
      }},
      'Session': {M: {
          'Token': {S: ''},
          'Issue Date': {S: ''}
      }}
    }
  };