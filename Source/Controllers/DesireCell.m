#import "DesireCell.h"


@implementation DesireCell

@synthesize logic = _logic;

#pragma mark Actions

-(IBAction)shareClick
{
	[_logic shareDesire:_desire];
}






#pragma mark Public Methods

-(void)setUserImage:(UIImage *)img
{
	_photo.image = img;

	[_indicator stopAnimating];
}


-(void)waitForPhoto
{
	[_indicator startAnimating];
}



-(void)applyData:(Desire *)desire
{	
	_desire = [desire retain];
	
	if ([desire.userName isKindOfClass:[NSString class]] == NO) 
	
		_lblUserName.text = @"";
	else 
		_lblUserName.text = [desire.userName retain];
	
	if ([desire.comment isKindOfClass:[NSString class]] == NO)
		_textComment.text = @"";
	else
		_textComment.text = [desire.comment retain];
	
	
	_desireId = desire.desireId;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
