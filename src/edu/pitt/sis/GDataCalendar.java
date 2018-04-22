package edu.pitt.sis;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.TimeZone;

import com.google.gdata.client.calendar.CalendarService;
import com.google.gdata.data.DateTime;
import com.google.gdata.data.Link;
import com.google.gdata.data.PlainTextConstruct;
import com.google.gdata.data.batch.BatchOperationType;
import com.google.gdata.data.batch.BatchStatus;
import com.google.gdata.data.batch.BatchUtils;
import com.google.gdata.data.calendar.AccessLevelProperty;
import com.google.gdata.data.calendar.CalendarAclRole;
import com.google.gdata.data.calendar.CalendarEntry;
import com.google.gdata.data.calendar.CalendarEventEntry;
import com.google.gdata.data.calendar.CalendarEventFeed;
import com.google.gdata.data.calendar.ColorProperty;
import com.google.gdata.data.calendar.HiddenProperty;
import com.google.gdata.data.calendar.SelectedProperty;
import com.google.gdata.data.calendar.TimeZoneProperty;
import com.google.gdata.data.calendar.WebContent;
import com.google.gdata.data.extensions.Recurrence;
import com.google.gdata.data.extensions.When;
import com.google.gdata.data.extensions.Where;
import com.google.gdata.util.AuthenticationException;
import com.google.gdata.util.ServiceException;

public class GDataCalendar {

	private final CalendarService service;
	
	// The base URL for a user's calendar metafeed (needs a username appended).
	private static final String METAFEED_URL_BASE = 
	    "https://www.google.com/calendar/feeds/";

	// The string to add to the user's metafeedUrl to access the allcalendars
	// feed.
	private static final String ALLCALENDARS_FEED_URL_SUFFIX = 
		"/allcalendars/full";

	// The string to add to the user's metafeedUrl to access the owncalendars
	// feed.
	private static final String OWNCALENDARS_FEED_URL_SUFFIX = 
		"/owncalendars/full";

	// The string to add to the user's metafeedUrl to access the event feed for
	// their primary calendar.
	private static final String EVENT_FEED_URL_SUFFIX = "/private/full";

	// The URL for the metafeed of the specified user.
	// (e.g. http://www.google.com/feeds/calendar/jdoe@gmail.com)
	private static URL metafeedUrl = null;

	// The URL for the allcalendars feed of the specified user.
	// (e.g. http://www.googe.com/feeds/calendar/jdoe@gmail.com/allcalendars/full)
	private static URL allcalendarsFeedUrl = null;

	// The URL for the owncalendars feed of the specified user.
	// (e.g. http://www.googe.com/feeds/calendar/jdoe@gmail.com/owncalendars/full)
	private static URL owncalendarsFeedUrl = null;

	// The HEX representation of red, blue and green
	private static final String RED = "#A32929";
	private static final String BLUE = "#2952A3";
	private static final String GREEN = "#0D7813";

	public GDataCalendar(String email,String password) {
		// TODO Auto-generated constructor stub

		// Create CalendarService and authenticate using ClientLogin
	    service = new CalendarService("cometpaws-calendarFeed");
	    
	    // Create necessary URL objects
	    try {
	      metafeedUrl = new URL(METAFEED_URL_BASE + email);
	      allcalendarsFeedUrl = new URL(METAFEED_URL_BASE + email + 
	          ALLCALENDARS_FEED_URL_SUFFIX);
	      owncalendarsFeedUrl = new URL(METAFEED_URL_BASE + email + 
	          OWNCALENDARS_FEED_URL_SUFFIX);
	    } catch (MalformedURLException e) {
	        // Bad URL
	        System.err.println("Uh oh - you've got an invalid URL.");
	        e.printStackTrace();
	        return;
	    }

	    try {
	      service.setUserCredentials(email, password);
	    } catch (AuthenticationException e) {
	      // Invalid credentials
	      e.printStackTrace();
	    }

	}

	  /**
	   * Creates a new secondary calendar using the owncalendars feed.
	   * 
	   * @param calendar The calendar entry to create.
	   * @return The newly created calendar entry.
	   * @throws IOException If there is a problem communicating with the server.
	   * @throws ServiceException If the service is unable to handle the request.
	   */
	  private CalendarEntry createCalendar(CalendarEntry calendar)
	      throws IOException, ServiceException {
	    System.out.println("Creating a secondary calendar: " + calendar.getTitle().getPlainText());
	    
	    calendar.setAccessLevel(AccessLevelProperty.READ);
	    
	    // Insert the calendar
	    return service.insert(owncalendarsFeedUrl, calendar);
	  }

	  /**
	   * Deletes the given calendar entry.
	   * 
	   * @param calendar The calendar entry to delete.
	   * @throws IOException If there is a problem communicating with the server.
	   * @throws ServiceException If the service is unable to handle the request.
	   */
	  private static void deleteCalendar(CalendarEntry calendar)
	      throws IOException, ServiceException {
	    System.out.println("Deleting the secondary calendar: " + calendar.getTitle().getPlainText());

	    calendar.delete();
	  }

	  /**
	   * Helper method to create either single-instance or recurring events. 
	   * 
	   * @param calendar The calendar entry to create event.
	   * @param entry The event to create.
	   * @return The newly-created CalendarEventEntry.
	   * @throws ServiceException If the service is unable to handle the request.
	   * @throws IOException Error communicating with the server.
	   */
	  private CalendarEventEntry createEvent(CalendarEntry calendar, CalendarEventEntry myEntry) 
	  	throws ServiceException, IOException {
		
		URL eventFeedUrl = new URL(METAFEED_URL_BASE + calendar.getId() + EVENT_FEED_URL_SUFFIX);
		
	    // Send the request and receive the response:
	    return service.insert(eventFeedUrl, myEntry);
	  }

	  /**
	   * Makes a batch request to delete all the events in the given list. If any of
	   * the operations fails, the errors returned from the server are displayed.
	   * The CalendarEntry objects in the list given as a parameters must be entries
	   * returned from the server that contain valid edit links (for optimistic
	   * concurrency to work). Note: You can add entries to a batch request for the
	   * other operation types (INSERT, QUERY, and UPDATE) in the same manner as
	   * shown below for DELETE operations.
	   * 
	   * @param calendar The calendar entry to create event.
	   * @param eventsToDelete A list of CalendarEventEntry objects to delete.
	   * @throws ServiceException If the service is unable to handle the request.
	   * @throws IOException Error communicating with the server.
	   */
	  private void deleteEvents(CalendarEntry calendar,
	      List<CalendarEventEntry> eventsToDelete) throws ServiceException,
	      IOException {

	    // Add each item in eventsToDelete to the batch request.
	    CalendarEventFeed batchRequest = new CalendarEventFeed();
	    for (int i = 0; i < eventsToDelete.size(); i++) {
	      CalendarEventEntry toDelete = eventsToDelete.get(i);
	      // Modify the entry toDelete with batch ID and operation type.
	      BatchUtils.setBatchId(toDelete, String.valueOf(i));
	      BatchUtils.setBatchOperationType(toDelete, BatchOperationType.DELETE);
	      batchRequest.getEntries().add(toDelete);
	    }

		URL eventFeedUrl = new URL(METAFEED_URL_BASE + calendar.getId() + EVENT_FEED_URL_SUFFIX);

		// Get the URL to make batch requests to
	    CalendarEventFeed feed = service.getFeed(eventFeedUrl,
	        CalendarEventFeed.class);
	    Link batchLink = feed.getLink(Link.Rel.FEED_BATCH, Link.Type.ATOM);
	    URL batchUrl = new URL(batchLink.getHref());

	    // Submit the batch request
	    CalendarEventFeed batchResponse = service.batch(batchUrl, batchRequest);

	    // Ensure that all the operations were successful.
	    boolean isSuccess = true;
	    for (CalendarEventEntry entry : batchResponse.getEntries()) {
	      String batchId = BatchUtils.getBatchId(entry);
	      if (!BatchUtils.isSuccess(entry)) {
	        isSuccess = false;
	        BatchStatus status = BatchUtils.getBatchStatus(entry);
	        System.out.println("\n" + batchId + " failed (" + status.getReason()
	            + ") " + status.getContent());
	      }
	    }
	    if (isSuccess) {
	      System.out.println("Successfully deleted all events via batch request.");
	    }
	  }

	  
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
