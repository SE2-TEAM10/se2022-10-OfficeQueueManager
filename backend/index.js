'use strict';

const express = require('express');
const morgan = require('morgan'); // logging middleware
const Database = require('./database.js')
const db = new Database('./oqm.db')
const passport = require('passport'); // auth middleware
const LocalStrategy = require('passport-local').Strategy; // username and password for login
const session = require('express-session'); // enable sessions
const cors = require('cors');
const { check, validationResult, body, param } = require('express-validator'); // validation middleware
const dayjs = require('dayjs');


/*** Set up Passport ***/
// set up the "username and password" login strategy
// by setting a function to verify username and password
passport.use(
  new LocalStrategy(async function verify(username, password, cb) {
    const user = await db.login(username, password)
    if (!user) return cb(null, false, 'Incorrect username or password.')

    return cb(null, user)
  })
)


// serialize and de-serialize the user (user object <-> session)
// we serialize the user id and we store it in the session: the session is very small in this way
passport.serializeUser((user, done) => {
  done(null, user.id);
});

// starting from the data in the session, we extract the current (logged-in) user
passport.deserializeUser((id, done) => {
  db.getUserById(id).then(user => {
    done(null, user); // this will be available in req.user
  }).catch(err => {
    done(err, null);
  });
});


// init express
const app = express();
const port = 3001;

// set-up the middlewares
app.use(morgan('dev'));
app.use(express.json());
const corsOptions = {
  origin: 'http://localhost:8000',
  credentials: true,
};
app.use(cors(corsOptions));

// custom middleware: check if a given request is coming from an authenticated user
const isLoggedIn = (req, res, next) => {
  if (req.isAuthenticated())
    return next();

  return res.status(401).json({ error: 'not authenticated' });
}

// set up the session
app.use(session({
  // by default, Passport uses a MemoryStore to keep track of the sessions
  secret: 'a secret sentence not to share with anybody and anywhere, used to sign the session ID cookie',
  resave: false,
  saveUninitialized: false
}));

// then, init passport
app.use(passport.initialize());
app.use(passport.session());


// POST /sessions 
// login
app.post('/api/sessions', function (req, res, next) {
  passport.authenticate('local', (err, user, info) => {
    if (err)
      return next(err);
    if (!user) {
      // display wrong login messages
      return res.status(401).json(info);
    }
    // success, perform the login
    req.login(user, (err) => {
      if (err)
        return next(err);
      return res.json(req.user);
    });
  })(req, res, next);
});

// DELETE /sessions/current 
// logout
app.delete('/api/sessions/current', (req, res) => {
  req.logout(() => { res.end(); });
});

// GET /sessions/current
// check whether the manager is logged in or not
app.get('/api/sessions/current', (req, res) => {
  if (req.isAuthenticated()) {
    res.status(200).json(req.user);
  }
  else
    res.status(401).json({ error: 'Unauthenticated user!' });;
});


/*** OQM APIs ***/

// GET /api/services   
app.get('/api/services',
  /*isLoggedIn,*/
  (req, res) => {
    db.getServices()
      .then(services => res.json(services))
      .catch((err) => res.status(500).json(err));
  });


// GET /api/service/<id> 
app.get('/api/service/:id',
  /*isLoggedIn,*/
  [check('id').isInt()],
  async (req, res) => {
    try {
      const result = await db.getService(req.params.id);
      if (result.error)
        res.status(404).json(result);
      else
        res.json(result);
    } catch (err) {
      res.status(500).end();
    }
  });

// GET /api/officers   
app.get('/api/officers',
  /*isLoggedIn,*/
  (req, res) => {
    db.getOfficers()
      .then(officers => res.json(officers))
      .catch((err) => res.status(500).json(err));
  });

// GET /api/officer/<id>
app.get('/api/officer/:id',
  /*isLoggedIn,*/
  [check('id').isInt()],
  async (req, res) => {
    try {
      const result = await db.getOfficer(req.params.id);
      if (result.error)
        res.status(404).json(result);
      else
        res.json(result);
    } catch (err) {
      res.status(500).end();
    }
  });

// POST /api/service
app.post('/api/service',
  /*isLoggedIn,*/
  [
    check('id').isInt({ min: 1, max: 100 }),
    check('tag_name').isLength({ min: 1, max:100 }),
    check('service_time').notEmpty()
  ], 
  async (req, res) => {

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(422).json({ error: errors.array().join(", ") });
    } 

    const service = {
      id: req.body.id,
      tag_name: req.body.tag_name,
      service_time: req.body.service_time,
    };

    try {
      const result = await db.createService(service);
      res.json(result);
    } catch (err) {
      res.status(503).json({ error: `Database error during the creation of new service: ${err}` });
    }
  });

// GET /api/OfficerService 
app.get('/api/OfficerService/:id',
  /*isLoggedIn,*/
  (req, res) => {
    db.getOfficerServices(req.params.id)
      .then(of_ser => res.json(of_ser))
      .catch((err) => res.status(500).json(err));
  });

// POST /api/OfficerService
app.post('/api/OfficerService',
  /*isLoggedIn,*/
  /*[
    check('id_of').isInt({ min: 1, max: 5 }),
    check('id_ser').isInt({ min: 1, max: 5 }),
  ], */
  async (req, res) => {

    /* const errors = validationResult(req).formatWith(errorFormatter);
    if (!errors.isEmpty()) {
      return res.status(422).json({ error: errors.array().join(", ") });
    } */

    try {
      const result = await db.createOfficerService(req.body.id_of, req.body.id_ser);
      res.json(result);
    } catch (err) {
      res.status(503).json({ error: `Database error during the creation of new officer service: ${err}` });
    }
  });


// PUT /api/OfficerService

/*app.put('/api/OfficerService', async (req, res) => { 
      try {
          await db.updateOfficerService(req.body.id_of,req.body.ser);
          res.status(200).end();
      }
      catch (err) {
          console.error(err);
          res.status(503).json({ error: `Database error while updating.` });
      }

});*/


// DELETE /api/OfficerService

app.delete('/api/OfficerService',
  /*isLoggedIn,*/
  /*[
  check('id_of').isInt({ min: 1, max: 5 }),
  check('id_ser').isInt({ min: 1, max: 5 }),
], */
  async (req, res) => {
    try {
      await db.deleteOfficerService(req.body.id_of, req.body.id_ser);
      res.status(200).json({});
    } catch (err) {
      res.status(503).json({ error: `Database error during the deletion of officer service with of_id ${req.body.id_of} and id_ser ${req.body.id_ser}: ${err} ` });
    }
  });

// Activate the server
app.listen(port, () => {
  console.log(`server listening at http://localhost:${port}`);
});
