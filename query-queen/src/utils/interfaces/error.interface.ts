export interface IError {
	code: number;
	error: string;
	additional: JSON;
	info: 'execko';
}