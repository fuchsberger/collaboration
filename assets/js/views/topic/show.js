import $ from 'jquery'
import MainView from '../main'

export default class View extends MainView {

  comment(id, cid, author, text, delay){

    var date = new Date()
    date = new Date(date.getTime() + delay * 1000 )
    date = date.toISOString()
    const comment = `<li id="comment${cid}" class="list-group-item pb-1 pt-2 comment" data-liked="false" data-likes="0" data-remaining="0">
    <p class="mb-0 text-justify">
      <small><strong class="mr-1">${author}</strong>${text}</small>
    </p>
    <p class=" mb-1">
      <small>
        <i class="text-primary far fa-thumbs-up"></i>
        <span class="likes badge badge-pill badge-primary mr-1 d-none">0</span>
        <small class="text-primary" drab-click="like(${cid})" drab="click:like(${cid})">Like</small>
        <time class="font-italic float-right" datetime="${date}"></time>
      </small>
    </p>
  </li>`;

    switch($(`#idea${id} .comment`).length){
      case 0:
      case 1:
        $(`#idea${id} .comments`).append(comment).find('time').timeago()
        break;
      default:
        let done = false
        $(`#idea${id} .comment`).each(function(){
          if(done) return false;
          if($(this).find('time').attr('datetime') > date ){
            $(this).before(comment).find('time').timeago()
            done = true
          }
        });
    }
    window.user.comments.push(cid);
  }

  schedule_comment(idea_id, cid, author, text, delay){
    if(window.time_passed < delay){
      const View = this;
      setTimeout(
        function(){ View.comment(idea_id, cid, author, text, delay)},
        1000 * (delay - window.time_passed)
      )
    }
    else
      this.comment(idea_id, cid, author, text, delay)
  }

  like(comment_id){
    const comment = $(`#comment${comment_id}`)
    const likes = comment.data('likes')
    comment
      .data('likes', likes + 1)
      .find('.likes').text(likes + 1).removeClass('d-none')
  }

  rate(idea_id, newRating){
    const ratingElm = $(`#idea${idea_id} .rating strong`)
    const ratersElm = $(`#idea${idea_id} .raters strong`)
    const uRatingElm = $(`#idea${idea_id} .user-rating strong`)
    const rating = parseFloat(ratingElm.text()) || 0
    const raters = parseInt(ratersElm.text())
    const uRating = parseInt(uRatingElm.text())

    let finalRating = uRating
      ? (newRating + uRating + rating * raters) / (raters + 1)
      : (newRating + rating * raters) / (raters + 1)
    finalRating = Math.round(finalRating * 100) / 100

    ratingElm.text(finalRating)
    ratersElm.text(raters +1)
  }

  schedule_like(comment_id, delay){
    if(window.time_passed < delay)
      setTimeout(this.like(comment_id), 1000 * (delay - window.time_passed))
    else
      this.like(comment_id)
  }

  schedule_rating(idea_id, rating, delay){
    if(window.time_passed < delay)
      setTimeout(this.rate(idea_id, rating), 1000*(delay - window.time_passed))
    else
      this.rate(idea_id, rating)
  }

  mount() {
    super.mount();

    // enables to submit feedback with Enter, but not shift enter (new line)
    $(".idea textarea").keypress(function (e) {
      if(e.which == 13 && !e.shiftKey) {
        // validate form
        const txt = $(e.target).val()
        if(txt.length < 10 || txt.length > 200){
          $(e.target).addClass('is-invalid')
          $(e.target).siblings('.invalid-feedback').text('Comment need to have between 10 and 200 characters.')
          return false;
        }

        // create event handlers for saving scroll position
        localStorage.setItem('scroll-pos', $(window).scrollTop());

        $(this).closest("form").submit();
        e.preventDefault();
        return false;
      }
    });

    // toggles star rating for submitting a user rating
    $("body").on('click', '.user-rating', (e) => {
      $(e.currentTarget).siblings().toggle()
    })

    // enable delayed ideas that are not yet posted
    $('.idea.d-none').each(function(){
      const elm = this
      setTimeout(function(){
        $(elm).removeClass('d-none').addClass('new').parent().prepend(elm)
      }, $(elm).data('remaining') * 1000)
    })

    // enable delayed comments that are not yet posted
    $('.comment.d-none').each(function(){
      const elm = this
      setTimeout(function(){
        $(elm).removeClass('d-none').addClass('new').parent().append(elm)
      }, $(elm).data('remaining') * 1000)
    })

    // enable delayed likes
    switch(window.condition){
      case 5:
      case 7:
        this.schedule_like(12, 530)
        this.schedule_like(13, 180)
        this.schedule_like(18, 90)
        this.schedule_rating(6, 4.4, 75)
        this.schedule_rating(7, 4.7, 360)
        break
      case 6:
      case 8:
        this.schedule_like(1, 530)
        this.schedule_like(2, 180)
        this.schedule_like(6, 90)
        this.schedule_rating(1, 4.4, 75)
        this.schedule_rating(2, 4.7, 360)
    }

    // answer with a new comment to the first two user_ideas
    if([3,4,7,8].indexOf(window.condition) >= 0 && window.respond_to.length>0){

      const r1 = window.respond_to[0]
      const r2 = window.respond_to[1] || null

      switch(window.condition){
        case 3:
          this.schedule_comment(r1[0], 25, "chemistrynerd1994", "that’s crazy!", r1[1] + 40)
        case 4:
          this.schedule_comment(r1[0], 25, "3-DMan", "Bingo!", r1[1] + 40)
        case 7:
          this.schedule_comment(r1[0], 25, "chemistrynerd1994", "that’s crazy!", r1[1] + 40)
        case 8:
          this.schedule_comment(r1[0], 25, "3-DMan", "Bingo!", r1[1] + 40)
          // if(r2) this.schedule_comment(r1[0], 24, "3-DMan", "Bingo!", r1[1] + 40)
      }
    }
  }

  unmount() {
    super.unmount();
  }
}
