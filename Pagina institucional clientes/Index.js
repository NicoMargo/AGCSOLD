

const express = require('express');
const morgan = require('morgan');
const app = express();
const exphbs = require('express-handlebars');
const path = require('path');

app.set('port', process.env.PORT || 4000 );
app.engine('.hbs', exphbs({
	defaultLayout: 'main',
	layoutsdir: path.join(app.get('views'), 'layouts'),
	partialdir: path.join(app.get('views'), 'partials'),
	extname: '.hbs',
	helpers: require('./Public/JS/Handlebars')
}));

app.set('view engine', '.hbs');

//Global Variables
app.use((req, res, nest)=>{
next();
});
//middlewars
app.use(express.urlencoded({extended: false}));
app.use(express.json());
app.use(morgan('dev'));

//Routes
app.use(require('./Routes/Index'));
app.use(require('./Routes/Authentication'));
app.use('/links',require('./Routes/Links'));
// Public
app.use(express.static(path.join(__dirname, 'Public')));
// Starting the server
app.listen(app.get('port'),() => {
	console.log('server on port', app.get('port'));
});