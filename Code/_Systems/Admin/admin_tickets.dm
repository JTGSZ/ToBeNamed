GLOB_VAR(datum/admin_ticket_holder/admin_tickets) = new()

/*	
	The singleton datum holder for all the tickets
*/
/datum/admin_ticket_holder
	var/list/open_tickets = list()
	var/list/closed_tickets = list()

	var/on_ticket_num = 1

/datum/admin_ticket_holder/proc/stat_entry()
	stat("Open Tickets: [open_tickets.len]")
	stat("Closed Tickets: [closed_tickets.len]")
	
	stat(null)

/datum/admin_ticket_holder/Topic(href, href_list)
	. = ..()
	


/datum/admin_ticket_holder/proc/new_ticket(client/C, entry_message)
	if(!entry_message)
		return FALSE

	var/datum/admin_ticket/new_ticket = new()
	new_ticket.ticket_number = on_ticket_num
	on_ticket_num++
	open_tickets += new_ticket
	new_ticket.add_participant(C)
	new_ticket.start_ticket(C, entry_message)

	return new_ticket

/*	
	Data holder for a admin ticket
*/
/datum/admin_ticket
// Ticket number this session
	var/ticket_number = 1

// Whether the ticket is still open
	var/ticket_open = TRUE

// The first message used to startup this ticket
	var/list/ticket_log = list()

// Ckey of the person who started the ticket
	var/starter_ckey

// String to display on the stats ticket panel
	var/stat_string
// The object on the stats panel 
	var/obj/stat_click_object/admin_ticket/stat_click_object

// The client who sent in the ticket
	var/client/target_client

// Any person participating in this ticket
// We use ckeys mostly cause a ref to a client would drop the moment they disconnect
	var/list/participating_ckeys = list()


/datum/admin_ticket/proc/add_participant(client/C)
	participating_ckeys += C.ckey

/datum/admin_ticket/proc/start_ticket(client/caller_client, first_message)
	var/cmd_list = "(<a href='byond://?src=\ref[src];TicketREPLY=1'>Reply</a>)"
	first_message = "[caller_client.key]: [first_message]"

	starter_ckey = caller_client.ckey
	ticket_log += first_message
	stat_string = first_message

	for(var/client/C in GLOB.clients)
		if(C.ckey in participating_ckeys)
			if(C.admin_data) // Give them some admin buttons as these participants are admins
				cmd_list = "[cmd_list] (<a href='byond://?src=\ref[src];TicketCLOSE=1'>Close</a>)"

			first_message = span_redtext("[first_message] [cmd_list]")
			var/datum/message_data/msg_data = new(caller_client, first_message)
			C.receive_message(msg_data)

/datum/admin_ticket/Topic(href, href_list)
	. = ..()
	var/client/caller_client = usr

	if(href_list["TicketREPLY"])
		if(!ticket_open)
			ez_output(caller_client, "This ticket is closed")
			return

		var/reply_message = input(caller_client, "What would you like to reply with?") as message
		if(reply_message)

			if(!caller_client.ckey in participating_ckeys)
				participating_ckeys += caller_client.ckey

			var/cmd_list = "(<a href='byond://?src=\ref[src];TicketREPLY=1'>Reply</a>)"
			reply_message = "[caller_client.key]: [reply_message] "
			ticket_log += reply_message

			if(caller_client.ckey == starter_ckey)
				stat_string = reply_message

			for(var/client/C in GLOB.clients)
				if(C.ckey in participating_ckeys)
					if(C.admin_data) // Give them some admin buttons as these participants are admins
						cmd_list = "[cmd_list] (<a href='byond://?src=\ref[src];TicketCLOSE=1'>Close</a>)"

					reply_message = span_redtext("[reply_message] [cmd_list]")
					var/datum/message_data/msg_data = new(caller_client, reply_message)
					C.receive_message(msg_data)

	if(href_list["TicketCLOSE"])
		ticket_open = FALSE
		GLOB.admin_tickets.open_tickets -= src
		GLOB.admin_tickets.closed_tickets += src

		var/message = span_redtext("Ticket #[ticket_number] closed by [caller_client.key]")
		ticket_log += message

		for(var/client/C in GLOB.clients)
			if(C.ckey in participating_ckeys)
				var/datum/message_data/msg_data = new(caller_client, message)
				C.receive_message(msg_data)


/datum/admin_ticket/proc/display_menu(client/requestor)
	var/html = ""
	var/participants_string = "<div>Participants:"
	for(var/participants in participating_ckeys)
		participants_string += "([participants])"
	html += "[participants_string]</div>"

	html += {"
		<div>
			(<a href='byond://?src=\ref[src];TicketREPLY=1'>Reply</a>)
			(<a href='byond://?src=\ref[src];TicketCLOSE=1'>Close</a>)
		</div>
	"}
	html += "<div>TICKET LOG:</div>"
	for(var/strings in ticket_log)
		html += "<div>[strings]</div>"

	html += "</div>"

	var/datum/browser/our_window = new(requestor, "admin_ticket_[ticket_number]", "Ticket UI", 600, 450, src)
	our_window.html_content = html
	our_window.quickset_stylesheet(STYLESHEET_SS13_COMMON)
	our_window.fire_browser()

/datum/admin_ticket/proc/stat_entry()
	if(!stat_click_object)
		stat_click_object = new /obj/stat_click_object/admin_ticket("Initializing...", src)
		stat_click_object.linked_ticket = src

	stat("#[ticket_number]:", stat_click_object.update_text("<b>KEY:</b> [stat_string]"))

/*
	The clickable stat button for the tickets
*/
/obj/stat_click_object/admin_ticket
	var/datum/admin_ticket/linked_ticket

/obj/stat_click_object/admin_ticket/Click()
	linked_ticket.display_menu(usr)



	
