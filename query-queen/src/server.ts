require("dotenv").config();

import cors from "cors";
import multer from "multer";
import passport from 'passport';
import { QueryResult } from "pg";
import session from 'express-session';
import cookieParser from "cookie-parser";
import express, { Request, Response, NextFunction } from "express";

import RouterUtil from "./utils/routes.util";
import DatabaseUtil from "./utils/database.util";
import ResponsesUtil from "./utils/responses.util";

/**
 * 	GLOBAL VARIABLES
 */
const upload = multer();
const app = express();

app.set("port", process.env.SERVER_PORT);
app.set("env", process.env.NODE_ENV);

app.set("dbHost", process.env.DB_HOST);
app.set("dbPort", process.env.DB_PORT);
app.set("dbUser", process.env.DB_USER);
app.set("dbPsswd", process.env.DB_PASSWORD);

app.set("version", process.env.VERSION);
app.set("baseUrl", process.env.BASE_URL);

app.set("secret", process.env.SECRET);

/**
 * 	USES
 */
app.use(cors());
app.use(express.json());
app.use(express.text());
app.use(express.urlencoded({extended: true}));
app.use(upload.array("data"));
app.use(express.static('public'));
app.use(cookieParser());
app.use(
	session({
		secret: app.get('secret'),
		saveUninitialized: true,
		resave: false,
		cookie: {
			maxAge: 1000*60*60*24*365 // 1 Year
		}
	})
);
app.use(passport.initialize());
app.use(passport.session());

/**
 * 	ROUTER
 */
RouterUtil.init(app);

app.get('/', (req: Request, res: Response, next: NextFunction) => {
    if(!req.user) res.status(200).send({status: `Welcome to our virtual universe newbie 🌍`});
	else res.status(200).send(req.user);
});

app.use((req: Request, res: Response, next: NextFunction) => {
    ResponsesUtil.notFound(res);
});

app.use((err: any, req: Request, res: Response, next: NextFunction) => {
    ResponsesUtil.somethingWentWrong(res);
});

/**
 * 	CORE
 */
DatabaseUtil.init(app);

app.listen(app.get('port'), () => {
    DatabaseUtil.pool.query(`SELECT 'App Started on :${app.get('port')} !' as started`, (err: Error, res: QueryResult<any>) => {
        if(err) throw err;
        console.log(res.rows[0].started);
    });
});

export default app;