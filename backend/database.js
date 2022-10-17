'use strict'

const sqlite = require('sqlite3')
const crypto = require('crypto')


class Database {
    constructor(dbName) {
        this.db = new sqlite.Database(dbName, (err) => {
            if (err) throw err
        })
    }

    getServices = () => {
        return new Promise((resolve, reject) => {
            const sql = 'SELECT * FROM service'
            this.db.all(sql, (err, rows) => {
                if (err) return reject('INTERNAL')
                return resolve(rows)
            })
        })
    }

    getService = (id) => {
        return new Promise((resolve, reject) => {
            if (isNaN(id)) return reject('UNPROCESSABLE')
            const sql = 'SELECT * FROM service WHERE id = ?'
            this.db.get(sql, [id], (err, row) => {
                if (err) return reject('INTERNAL')
                if (row === undefined) return reject('NOT_FOUND')
                return resolve(row)
            })
        })
    }

    getOfficer = (id) => {
        return new Promise((resolve, reject) => {
            if (isNaN(id)) return reject('UNPROCESSABLE')
            const sql = 'SELECT * FROM officer WHERE id = ?'
            this.db.get(sql, [id], (err, row) => {
                if (err) return reject('INTERNAL')
                if (row === undefined) return reject('NOT_FOUND')
                return resolve(row)
            })
        })
    }

    //adding a service to the "service" table
    createService = (service) => {
        return new Promise((resolve, reject) => {
            try {
                if (
                    typeof service.id !== 'int' ||
                    typeof service.tag_name !== 'string' ||
                    typeof service.service_time !== 'string'
                ) {
                    return reject('UNPROCESSABLE')
                }
            } catch (e) {
                return reject('UNAVAILABLE')
            }
            const sql =
                'INSERT INTO service (id, tag_name, service_time) VALUES (?, ?, ?)'
            let ser_time = dayjs(service.service_time).format('HH:mm:ss')
            this.db.run(
                sql,
                [
                    service.id,
                    service.tag_name,
                    ser_time
                ],
                function (err) {
                    if (err) return reject('UNAVAILABLE')
                    if (this.changes > 0) return resolve('SUCCESS')
                }
            )
        })
    }

    createOfficerService = (id_of, id_ser) => {
        return new Promise((resolve, reject) => {
            if (isNaN(id_ser)) return reject('UNPROCESSABLE')
            const sql = 'SELECT * FROM service WHERE id = ?'
            this.db.get(sql, [id_ser], (err, row_ser) => {
                if (err) return reject('UNAVAILABLE')
                if (row_ser === undefined) return reject('NOT_FOUND')
                return resolve(
                    new Promise((resolve, reject) => {
                        if (isNaN(id_of)) return reject('UNPROCESSABLE')
                        const sql2 = 'SELECT * FROM officer WHERE id = ?'
                        this.db.get(sql2, [id_of], (err, row_of) => {
                            if (err) return reject('UNAVAILABLE')
                            if (row_of === undefined) return reject('NOT_FOUND')
                            return resolve(
                                new Promise((resolve, reject) => {
                                    const sql3 =
                                        'INSERT INTO officer_service(of_id, serv_id, total_queue) VALUES (?, ?, ?)'
                                    this.db.run(sql,[ row_of.id, row_ser.id, 0,],
                                        function (err) {
                                            if (err) return reject('UNAVAILABLE')
                                            if (this.changes > 0) return resolve('SUCCESS')
                                        }
                                    )
                                }
                                )
                            )
                        }
                        )
                    })
                )
            })
        })
    }

    /* updateOfficerService = (id_of, id_ser) => {
        return new Promise((resolve, reject) => {
            if (isNaN(id_ser)) return reject('UNPROCESSABLE')
            const sql = 'SELECT * FROM service WHERE id = ?'
            this.db.get(sql, [id_ser], (err, row_ser) => {
                if (err) return reject('UNAVAILABLE')
                if (row_ser === undefined) return reject('NOT_FOUND')
                return resolve(
                    new Promise((resolve, reject) => {
                        if (isNaN(id_of)) return reject('UNPROCESSABLE')
                        const sql2 = 'SELECT * FROM officer WHERE id = ?'
                        this.db.get(sql2, [id_of], (err, row_of) => {
                            if (err) return reject('UNAVAILABLE')
                            if (row_of === undefined) return reject('NOT_FOUND')
                            return resolve(
                                new Promise((resolve, reject) => {
                                    const sql3 =
                                        'INSERT INTO officer_service(of_id, serv_id, total_queue) VALUES (?, ?, ?)'
                                    this.db.run(sql,[ row_of.id, row_ser.id, 0,],
                                        function (err) {
                                            if (err) return reject('UNAVAILABLE')
                                            if (this.changes > 0) return resolve('SUCCESS')
                                        }
                                    )
                                }
                                )
                            )
                        }
                        )
                    })
                )
            })
        })
    } */

/* deleteFilm = (id, userId) => {
    return new Promise((resolve, reject) => {
        if (isNaN(id)) return reject('UNPROCESSABLE')
        const sql = 'DELETE FROM films WHERE id = ? AND user = ?'
        this.db.run(sql, [id, userId], function (err) {
            if (err) return reject('UNAVAILABLE')
            if (this.changes == 0) return reject('NOT_FOUND')
            else return resolve('SUCCESS')
        })
    })
} */

login = (username, password) => {
                return new Promise((resolve, reject) => {
                    const sql = `SELECT * FROM users WHERE email = ?`
                    this.db.get(sql, [username], (err, row) => {
                        if (err) {
                            resolve(false)
                        } else if (row === undefined) {
                            resolve(false)
                        } else {
                            const user = { id: row.id, username: row.email, name: row.name }

                            crypto.scrypt(password, row.salt, 32, function (err, hashedPassword) {
                                if (err) reject(err)
                                if (!crypto.timingSafeEqual(Buffer.from(row.hash, 'hex'), hashedPassword))
                                    resolve(false)
                                else resolve(user)
                            })
                        }
                    })
                })
            }
}

module.exports = Database