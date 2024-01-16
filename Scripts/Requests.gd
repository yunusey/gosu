extends Node

const WORKING_STATUSES = [
	HTTPClient.STATUS_CONNECTING, 
	HTTPClient.STATUS_RESOLVING,
	HTTPClient.STATUS_REQUESTING,
]

## Checks if [code]username[/code] and [code]password[/code] are valid.
## Returns a dictionary containing these keys:
## - is_authorized: bool
## - is_username_found: bool
func check_login(username: String, password: String) -> Dictionary:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	var req_body := JSON.stringify({
		"username": username,
		"password": password,
	})
	http_request.request(
		"https://gosu-backend.vercel.app/login",
		["Content-Type: application/json"],
		HTTPClient.METHOD_GET,
		req_body
	)
	var result = JSON.parse_string((await http_request.request_completed)[3].get_string_from_utf8())
	return result

## Creates a new user using **username** and **password**.
## Returns if the user was created successfully.
func create_user(username: String, password: String) -> bool:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	var req_body := JSON.stringify({
		"username": username,
		"password": password,
	})
	http_request.request(
		"https://gosu-backend.vercel.app/login",
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		req_body
	)
	var result = JSON.parse_string((await http_request.request_completed)[3].get_string_from_utf8())
	return result["success"]

## Submit score to API. Returns if the score was submitted successfully.
func submit_score(username: String, password: String, score: int, level: int) -> bool:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	var req_body := JSON.stringify({
		"user": {
			"username": username,
			"password": password,
		},
		"score": score,
		"level": level
	})
	http_request.request(
		"https://gosu-backend.vercel.app/score",
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		req_body
	)
	var result = JSON.parse_string((await http_request.request_completed)[3].get_string_from_utf8())
	return result["success"]

## Retrieve score from API. Returns a list of scores.
func get_scores() -> Dictionary:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request(
		"https://gosu-backend.vercel.app/score",
		["Content-Type: application/json"],
		HTTPClient.METHOD_GET
	)
	var result = JSON.parse_string((await http_request.request_completed)[3].get_string_from_utf8())
	return result
