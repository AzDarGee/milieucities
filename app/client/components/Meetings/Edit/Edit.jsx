import React, { Component } from 'react'
import { TextAreaWithLabel, TextInputWithLabel, SelectWithLabel, MilieuDatePicker } from '../../Common/FormFields/Form'
import css from '../../Layout/Dashboard/dashboard.scss'
import i18n from '../../DevSites/Form/locale.js'
import moment from 'moment'

const MEETING_TYPES = [
  'Public',
  'Council'
]

export default class Edit extends Component {
  constructor(props) {
    super(props);
    const meetingDate = this.props.meeting ? this.props.meeting.date : null;
    this.state = { meetingDate };
    this.handleMeetingDate = (d) => this._handleMeetingDate(d)
    this.onDelete = (e) => this._onDelete(e)
    this.onSave = (e) => this._onSave(e)
  }

  _handleMeetingDate(date) {
    this.setState({ meetingDate: date });
  }

  _onDelete(e) {
    e.preventDefault();
    this.props.handleDeleteMeeting(this.props.status.id, this.props.meeting.id);
  }

  _onSave(e) {
    e.preventDefault();
    const data = new FormData(e.currentTarget);
    const meetingId = this.props.meeting ? this.props.meeting.id : null;
    this.props.handleSaveMeeting(data, this.props.status.id, meetingId);
  }


  render() {
    return (
      <div className={css.meta}>
        <div className={css.label}>
          {i18n.meeting}
        </div>
        <div className={css.data}>
          <form encType='multipart/form-data' onSubmit={this.onSave} acceptCharset='UTF-8'>
            <div className='row'>
              <TextInputWithLabel
                classes='col s12'
                id='meeting_title'
                name='meeting[title]'
                defaultValue={ this.props.meeting ? this.props.meeting.title : '' }
                label={i18n.title}
                />

              <SelectWithLabel
                classes='col s12'
                id='meeting_type'
                name='meeting[meeting_type]'
                label={ i18n.meetingType }
                defaultValue={ this.props.meeting ? this.props.meeting.meeting_type : null }
                options={ MEETING_TYPES.map(s => [s,s]) }
                />

              <div className='input-field col s12 m12 l6'>
                <label htmlFor='meeting_date'>{ i18n.meetingDate }</label>
                <MilieuDatePicker
                  selected={ this.state.meetingDate }
                  dateFormat='MMMM DD, YYYY'
                  name='meeting[date]'
                  onChange={ this.handleMeetingDate }
                />
                {
                  this.props.error &&
                  <div className='error-message'>{this.props.error['meetings.date']}</div>
                }
              </div>

              <TextInputWithLabel
                classes='col s12 m12 l6'
                id='meeting_time'
                name='meeting[time]'
                defaultValue={ this.props.meeting ? this.props.meeting.time : '' }
                label={i18n.meetingTime}
                />

              <TextInputWithLabel
                classes='col s12'
                id='meeting_location'
                name='meeting[location]'
                defaultValue={ this.props.meeting ? this.props.meeting.location : '' }
                label={i18n.location}
                />

              <div className="col">
                <input type='submit' value={i18n.save} className='btn submit' />
              </div>

              {
                this.props.meeting &&
                <div className="col">
                  <button className='btn cancel' onClick={this.onDelete}>Delete</button>
                </div>
              }
            </div>
          </form>
        </div>
      </div>
    )
  }
}




